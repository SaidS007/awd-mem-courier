<?php

/**
* Copyright Maarch since 2008 under licence GPLv3.
* See LICENCE.txt file at the root folder for more details.
* This file is part of Maarch software.
*
*/

/**
* @brief Export Template Model
* @author dev@maarch.org
*/

namespace Resource\models;

use SrcCore\models\DatabaseModel;
use SrcCore\models\ValidatorModel;

class ExportTemplateModel
{
    public static function get(array $aArgs = [])
    {
        ValidatorModel::arrayType($aArgs, ['select', 'where', 'data', 'orderBy']);
        ValidatorModel::intType($aArgs, ['limit']);

        $aTemplates = DatabaseModel::select([
            'select'    => empty($aArgs['select']) ? ['*'] : $aArgs['select'],
            'table'     => ['exports_templates'],
            'where'     => empty($aArgs['where']) ? [] : $aArgs['where'],
            'data'      => empty($aArgs['data']) ? [] : $aArgs['data'],
            'order_by'  => empty($aArgs['orderBy']) ? [] : $aArgs['orderBy'],
            'limit'     => empty($aArgs['limit']) ? 0 : $aArgs['limit']
        ]);

        return $aTemplates;
    }

    public static function getByUserId(array $aArgs)
    {
        ValidatorModel::notEmpty($aArgs, ['userId']);
        ValidatorModel::intVal($aArgs, ['userId']);
        ValidatorModel::arrayType($aArgs, ['select']);

        $exportTemplates = DatabaseModel::select([
            'select'    => empty($aArgs['select']) ? ['*'] : $aArgs['select'],
            'table'     => ['exports_templates'],
            'where'     => ['user_id = ?'],
            'data'      => [$aArgs['userId']]
        ]);

        return $exportTemplates;
    }

    public static function create(array $aArgs)
    {
        ValidatorModel::notEmpty($aArgs, ['userId', 'format', 'data']);
        ValidatorModel::stringType($aArgs, ['format', 'delimiter', 'data']);
        ValidatorModel::intVal($aArgs, ['userId']);

        $nextSequenceId = DatabaseModel::getNextSequenceValue(['sequenceId' => 'export_templates_id_seq']); // EDISSYUM - ASY01 Ajout de modèle d'exportation PDF/CSV
        DatabaseModel::insert([
            'table'         => 'exports_templates',
            'columnsValues' => [
                'user_id'   => $aArgs['userId'],
                'format'    => $aArgs['format'],
                'delimiter' => empty($aArgs['delimiter']) ? null : $aArgs['delimiter'],
                'data'      => $aArgs['data']
            ]
        ]);

        return $nextSequenceId; // EDISSYUM - ASY01 Ajout de modèle d'exportation PDF/CSV | Remplacer true par $nextSequenceId
    }

    public static function update(array $aArgs)
    {
        ValidatorModel::notEmpty($aArgs, ['set', 'where', 'data']);
        ValidatorModel::arrayType($aArgs, ['set', 'where', 'data']);

        DatabaseModel::update([
            'table' => 'exports_templates',
            'set'   => $aArgs['set'],
            'where' => $aArgs['where'],
            'data'  => $aArgs['data']
        ]);

        return true;
    }

    // EDISSYUM - ASY01 Ajout de modèle d'exportation PDF/CSV
    public static function getModel(array $aArgs = [])
    {
        ValidatorModel::arrayType($aArgs, ['select', 'where', 'data', 'orderBy']);
        ValidatorModel::intType($aArgs, ['limit']);

        $aTemplates = DatabaseModel::select([
            'select'    => empty($aArgs['select']) ? ['*'] : $aArgs['select'],
            'table'     => ['export_templates'],
            'where'     => empty($aArgs['where']) ? [] : $aArgs['where'],
            'data'      => empty($aArgs['data']) ? [] : $aArgs['data'],
            'order_by'  => empty($aArgs['orderBy']) ? [] : $aArgs['orderBy'],
            'limit'     => empty($aArgs['limit']) ? 0 : $aArgs['limit']
        ]);

        return $aTemplates;
    }

    public static function getModelByUserId(array $args)
    {
        ValidatorModel::arrayType($args, ['select', 'where', 'data', 'orderBy']);

        $models = DatabaseModel::select([
            'select'    => empty($args['select']) ? ['*'] : $args['select'],
            'table'     => ['export_templates'],
            'where'     => empty($args['where']) ? [] : $args['where'],
            'data'      => empty($args['data']) ? [] : $args['data'],
            'order_by'  => empty($args['orderBy']) ? [] : $args['orderBy']
        ]);

        return $models;
    }

    public static function createModel(array $aArgs)
    {
        ValidatorModel::notEmpty($aArgs, ['user_id', 'label', 'query']);
        ValidatorModel::stringType($aArgs, ['format', 'query']);
        ValidatorModel::intVal($aArgs, ['userId']);

        DatabaseModel::insert([
            'table'         => 'export_templates',
            'columnsValues' => [
                'user_id'   => $aArgs['user_id'],
                'label'    => $aArgs['label'],
                'creation_date'    => $aArgs['creation_date'],
                'query'      => $aArgs['query']
            ]
        ]);

        return true;
    }

    public static function updateModel(array $aArgs)
    {
        ValidatorModel::notEmpty($aArgs, ['set', 'where', 'data']);
        ValidatorModel::arrayType($aArgs, ['set', 'where', 'data']);

        DatabaseModel::update([
            'table' => 'export_templates',
            'set'   => $aArgs['set'],
            'where' => $aArgs['where'],
            'data'  => $aArgs['data']
        ]);

        return true;
    }

    public static function deleteModelById(array $args)
    {
        ValidatorModel::notEmpty($args, ['where', 'data']);
        ValidatorModel::arrayType($args, ['where', 'data']);

        DatabaseModel::delete([
            'table' => 'export_templates',
            'where' => $args['where'],
            'data'  => $args['data']
        ]);

        return true;
    }

    public static function getAnnotation(array $args)
    {
        ValidatorModel::arrayType($args, ['select', 'where', 'data', 'orderBy']);

        $models = DatabaseModel::select([
            'select'    => empty($args['select']) ? ['*'] : $args['select'],
            'table' => ['notes n', 'users u'],
            'left_join' => ['n.user_id = u.id'],
            'where' => empty($args['where']) ? [] : $args['where'],
            'data'  => empty($args['data']) ? [] : $args['data'],
            'order_by'  => empty($args['orderBy']) ? [] : $args['orderBy']
        ]);
        return $models;
    }

    public static function getLabel(string $label) {
        if ($label == 'civility') {
            return _TO_CIVILITY;
        } else if ($label == 'firstname') {
            return _TO_FIRSTNAME;
        } else if ($label == 'lastname') {
            return _TO_LASTNAME;
        } else if ($label == 'function') {
            return _TO_FUNCTION;
        } else if ($label == 'company') {
            return _TO_COMPANY;
        } else if ($label == 'department') {
            return _TO_DEPARTEMENT;
        } else if ($label == 'email') {
            return _TO_EMAIL;
        } else if ($label == 'phone') {
            return _TO_PHONE;
        } else if ($label == 'address_additional1') {
            return _TO_ADDRESS_ADDITIONAL_1;
        } else if ($label == 'address_number') {
            return _TO_ADDRESS_NUMBER;
        } else if ($label == 'address_street') {
            return _TO_ADDRESS_STREET;
        } else if ($label == 'address_additional2') {
            return _TO_ADDRESS_ADDITIONAL_2;
        } else if ($label == 'address_postcode') {
            return _TO_ADDRESS_POSTCODE;
        } else if ($label == 'address_town') {
            return _TO_ADDRESS_TOWN;
        } else if ($label == 'address_country') {
            return _TO_ADDRESS_COUNTRY;
        } else if ($label == 'notes') {
            return _TO_NOTES;
        } else if ($label == 'sector') {
            return _TO_SECTOR;
        } else if ($label == 'customfield_1') {
            return _TO_CUSTOM_FIELD_1;
        } else if ($label == 'customfield_2') {
            return _TO_CUSTOM_FIELD_2;
        } else {
            return "";
        }
    }
    // END EDISSYUM - ASY01
}
