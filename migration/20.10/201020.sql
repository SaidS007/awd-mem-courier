-- *************************************************************************--
--                                                                          --
--                                                                          --
-- Model migration script - 20.10.19 to 20.10.20                            --
--                                                                          --
--                                                                          --
-- *************************************************************************--

-- Create a sequence and set value for each chronos found in parameters table
DO $$
DECLARE
  last_chrono text;
  chrono record;
  chrono_seq_name text;
BEGIN	
  -- Loop through each chrono found in parameters table
	FOR chrono IN (SELECT id, param_value_int as value FROM parameters WHERE id LIKE 'chrono_%') LOOP
		chrono_seq_name := CONCAT(chrono.id, '_seq');
		
    -- Check if sequence exist, if not create
		IF NOT EXISTS (SELECT 0 FROM pg_class where relname = chrono_seq_name ) THEN
		  EXECUTE 'CREATE SEQUENCE ' || chrono_seq_name || ' INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;';
		END IF;
    -- Set sequence value
		EXECUTE 'SELECT setVal(''' || chrono_seq_name ||''',' || chrono.value ||',false)';
   	END LOOP;
END
$$;

-- Create a sequence for chronos and update value in parameters table
CREATE OR REPLACE FUNCTION public.increase_chrono(chrono_seq_name text, chrono_id_name text) returns table (chrono_id bigint) as $$
DECLARE
    retval bigint;
BEGIN
    -- Check if sequence exist, if not create
    IF NOT EXISTS (SELECT 0 FROM pg_class where relname = chrono_seq_name ) THEN
      EXECUTE 'CREATE SEQUENCE ' || chrono_seq_name || ' INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;';
    END IF;
    -- Check if chrono exist in parameters table, if not create
    IF NOT EXISTS (SELECT 0 FROM parameters where id = chrono_id_name ) THEN
      EXECUTE 'INSERT INTO parameters (id, param_value_int) VALUES ( ''' || chrono_id_name || ''', 1)';
    END IF;
    -- Get next value of sequence, update the value in parameters table before returning the value
    SELECT nextval(chrono_seq_name) INTO retval;
	  UPDATE parameters set param_value_int = retval WHERE id =  chrono_id_name;
	  RETURN QUERY SELECT retval;
END;
$$ LANGUAGE plpgsql;


UPDATE parameters SET param_value_string = '20.10.20' WHERE id = 'database_version';
