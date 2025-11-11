#!/bin/sh

psql -U maarch -d MaarchCourrier < /home/sql/structure.sql
psql -U maarch -d MaarchCourrier < /home/sql/data_fr.sql
psql -U maarch -d MaarchCourrier < /home/sql/index_creation.sql

psql -U maarch -d MaarchCourrier -c "UPDATE configurations SET value='{\"java\":[],\"default\":\"\",\"onlyoffice\":{\"ssl\":true,\"uri\":\"onlyoffice.courrier.local\",\"port\":\"443\",\"token\":\"\",\"authorizationHeader\":\"Authorization\"}}' WHERE privilege='admin_document_editors'"
psql -U maarch -d MaarchCourrier -c "UPDATE docservers SET path_template='/opt/maarch/docservers/maarch_courrier/acknowledgement_receipts/' WHERE docserver_id='ACKNOWLEDGEMENT_RECEIPTS'"
psql -U maarch -d MaarchCourrier -c "UPDATE docservers SET path_template='/opt/maarch/docservers/maarch_courrier/archive_transfer/' WHERE docserver_id='ARCHIVETRANSFER'"
psql -U maarch -d MaarchCourrier -c "UPDATE docservers SET path_template='/opt/maarch/docservers/maarch_courrier/convert_attachments/' WHERE docserver_id='CONVERT_ATTACH'"
psql -U maarch -d MaarchCourrier -c "UPDATE docservers SET path_template='/opt/maarch/docservers/maarch_courrier/convert_resources/' WHERE docserver_id='CONVERT_MLB'"
psql -U maarch -d MaarchCourrier -c "UPDATE docservers SET path_template='/opt/maarch/docservers/maarch_courrier/ai/' WHERE docserver_id='FASTHD_AI'"
psql -U maarch -d MaarchCourrier -c "UPDATE docservers SET path_template='/opt/maarch/docservers/maarch_courrier/attachments/' WHERE docserver_id='FASTHD_ATTACH'"
psql -U maarch -d MaarchCourrier -c "UPDATE docservers SET path_template='/opt/maarch/docservers/maarch_courrier/resources/' WHERE docserver_id='FASTHD_MAN'"
psql -U maarch -d MaarchCourrier -c "UPDATE docservers SET path_template='/opt/maarch/docservers/maarch_courrier/fulltext_attachments/' WHERE docserver_id='FULLTEXT_ATTACH'"
psql -U maarch -d MaarchCourrier -c "UPDATE docservers SET path_template='/opt/maarch/docservers/maarch_courrier/fulltext_resources/' WHERE docserver_id='FULLTEXT_MLB'"
psql -U maarch -d MaarchCourrier -c "UPDATE docservers SET path_template='/opt/maarch/docservers/maarch_courrier/migration/' WHERE docserver_id='MIGRATION'"
psql -U maarch -d MaarchCourrier -c "UPDATE docservers SET path_template='/opt/maarch/docservers/maarch_courrier/templates/' WHERE docserver_id='TEMPLATES'"
psql -U maarch -d MaarchCourrier -c "UPDATE docservers SET path_template='/opt/maarch/docservers/maarch_courrier/thumbnails_attachments/' WHERE docserver_id='TNL_ATTACH'"
psql -U maarch -d MaarchCourrier -c "UPDATE docservers SET path_template='/opt/maarch/docservers/maarch_courrier/thumbnails_resources/' WHERE docserver_id='TNL_MLB'"
