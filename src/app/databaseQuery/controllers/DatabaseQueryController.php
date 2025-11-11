<?php

/**
 * Copyright Edissyum Consulting under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of MEM courrier software.
 */

/**
 * @brief DatabaseQuery Controller
 * @author arthur.mondon@edissyum.com
 * @details Route webservice pour récupérer des données dans la BDD
 */

namespace DatabaseQuery\controllers;

use Slim\Psr7\Request;
use SrcCore\http\Response;
use SrcCore\models\CoreConfigModel;
use Respect\Validation\Validator;
use SrcCore\models\DatabaseModel;

class DatabaseQueryController
{
    public function getData(Request $request, Response $response): Response
    {
        $requestData = $request->getParsedBody();

        $isValid = Validator::key('tableName', Validator::stringType()->notEmpty())
            ->key('filterColumn', Validator::stringType()->notEmpty())
            ->key('operator', Validator::stringType()->notEmpty())
            ->key('filterValue', Validator::stringType()->notEmpty())
            ->key('columns', Validator::arrayType()->notEmpty(), false)
            ->key('column', Validator::stringType()->notEmpty(), false)
            ->validate($requestData);

        if (!$isValid || (!isset($requestData['columns']) && !isset($requestData['column'])) || (isset($requestData['columns']) && isset($requestData['column']))) {
            return $response->withStatus(400)->withJson(['errors' => 'Invalid request: specify either "columns" (array) or "column" (string), not both.']);
        }

        $allowedTables = $this->getWhiteList();
        if(!in_array($requestData['tableName'], array_column($allowedTables, 'name'))) {
            return $response->withStatus(403)->withJson(['errors' => 'Table not allowed']);
        }

        if(isset($requestData['columns'])) {
            foreach($requestData['columns'] as $column) {
                if(!in_array($column, $allowedTables[array_search($requestData['tableName'], array_column($allowedTables, 'name'))]['columns'])) {
                    return $response->withStatus(403)->withJson(['errors' => 'Column not allowed']);
                }
            }
        } else {
            if(!in_array($requestData['column'], $allowedTables[array_search($requestData['tableName'], array_column($allowedTables, 'name'))]['columns'])) {
                return $response->withStatus(403)->withJson(['errors' => 'Column not allowed']);
            }
        }

        try {
            $conditions = [];
            $parameters = [];
            $operator = strtoupper($requestData['operator']);

            if ($operator === 'LIKE') {
                $conditions[] = "{$requestData['filterColumn']} LIKE ?";
                $parameters[] = "%{$requestData['filterValue']}%";
            } elseif ($operator === '=') {
                $conditions[] = "{$requestData['filterColumn']} = ?";
                $parameters[] = $requestData['filterValue'];
            } else {
                throw new \Exception("Unsupported operator: {$operator}");
            }

            $selectedColumns = isset($requestData['columns']) ? $requestData['columns'] : [$requestData['column']];

            $queryArgs = [
                'select' => $selectedColumns,
                'table' => [$requestData['tableName']],
                'where' => $conditions,
                'data' => $parameters,
            ];

            $result = DatabaseModel::select($queryArgs);

            return $response->withJson($result);
        } catch (\Exception $e) {
            return $response->withStatus(500)->withJson(['errors' => $e->getMessage()]);
        }
    }

    public function getWhiteList()
    {
        $whiteList = CoreConfigModel::getJsonLoaded(['path' => 'config/webServiceTablesWhiteList.json']);
        $allowedTables = [];
        foreach ($whiteList as $table) {
            $columns = CoreConfigModel::getColumns(['table' => $table]);
            $columns = array_column($columns, 'column_name');
            foreach ($columns as $key => $column) {
                if (stripos($column, 'password') !== false || stripos($column, 'token') !== false) {
                    unset($columns[$key]);
                }
            }
            $allowedTables[] = [
                'name'      => $table,
                'columns'   => array_values($columns)
            ];
        }

        return $allowedTables;
    }
}