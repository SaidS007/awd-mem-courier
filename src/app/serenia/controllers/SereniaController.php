<?php

/**
 * Copyright Edissyum Consulting under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of MEM courrier software.
 */

/**
 * @brief Serenia Controller
 * @author nathan.cheval@edissyum.com
 * @details Route webservice pour récupérer des données dans la BDD
 */

namespace Serenia\controllers;

use Convert\controllers\FullTextController;
use Convert\models\AdrModel;
use Docserver\models\DocserverModel;
use Resource\controllers\ResController;
use Resource\models\ResModel;
use Respect\Validation\Validator;
use Slim\Psr7\Request;
use SrcCore\http\Response;
use SrcCore\models\CoreConfigModel;
use Zend_Search_Lucene;
use Zend_Search_Lucene_Analysis_Analyzer;
use Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8Num_CaseInsensitive;
use Zend_Search_Lucene_Search_Query_Term;
use Zend_Search_Lucene_Search_QueryParser;

class SereniaController
{
    public function isEnabled(Request $request, Response $response): Response {
        $config = CoreConfigModel::getJsonLoaded(['path' => 'config/serenia.json']);
        if (!$config || !isset($config['enabled']) || !$config['enabled']) {
            return $response->withStatus(200)->withJson(['serenia_enabled' => false]);

        }
        return $response->withStatus(200)->withJson(['serenia_enabled' => true]);
    }

    public function askChatbot(Request $request, Response $response): Response {
        $data = $request->getParsedBody();
        if (!Validator::stringType()->notEmpty()->validate($data['message'])) {
            return $response->withStatus(400)->withJson(['errors' => 'Bad Request: message is not valid']);
        }

        $config = CoreConfigModel::getJsonLoaded(['path' => 'config/serenia.json']);
        if (!$config || !isset($config['enabled']) || !$config['enabled']) {
            return $response->withStatus(500)->withJson(['errors' => _SERENIA_DISABLED]);
        }

        if (!isset($config['chatbot']['url']) || !Validator::url()->validate($config['chatbot']['url'])) {
            return $response->withStatus(500)->withJson(['errors' => _SERENIA_URL_NOT_VALID]);
        }

        if (!isset($config['chatbot']['login']) && !isset($config['chatbot']['password'])) {
            return $response->withStatus(500)->withJson(['errors' => _SERENIA_CREDENTIALS_NOT_VALID]);
        }

        $secretKey = CoreConfigModel::getEncryptKey();

        $sereniaData = ['query' => $data['message']];

        if (isset($data['resId']) && !empty($data['resId'])) {
            $document = ResModel::getById(['resId' => $data['resId'], 'select' => ['path', 'format', 'version', 'filename', 'docserver_id']]);
            if (empty($document)) {
                return $response->withStatus(404)->withJson(['errors' => 'Document not found']);
            }

            if ($document['format'] !== 'pdf') {
                $convertedDocument = AdrModel::getDocuments([
                    'select'  => ['id', 'docserver_id', 'path', 'filename'],
                    'where'   => ['res_id = ?', 'type in (?)', 'version = ?'],
                    'data'    => [$data['resId'], ['PDF'], $document['version']],
                    'orderBy' => ["type='SIGN' DESC"],
                    'limit'   => 1
                ]);
                $document = $convertedDocument[0] ?? null;
            }

            if ($document) {
                $docserver = DocserverModel::getByDocserverId(['docserverId' => $document['docserver_id'], 'select' => ['path_template', 'docserver_type_id']]);
                if (empty($docserver['path_template']) || !is_dir($docserver['path_template'])) {
                    return $response->withStatus(500)->withJson(['errors' => 'Docserver does not exist']);
                }
                $filepath = $docserver['path_template'] . str_replace('#', DIRECTORY_SEPARATOR, $document['path']) . $document['filename'];
                if ($filepath && is_file($filepath) && is_readable($filepath)) {
                    exec("pdftotext -l 1 " . escapeshellarg($filepath) . " -", $output);
                    $output = implode(" ", $output);
                    $sereniaData['letter_context'] = $output;
                }
            }
        }

        $ch = curl_init($config['chatbot']['url']);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($sereniaData));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, false);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Accept: application/json',
            'X-Api-Key: ' . $secretKey,
            'Content-Type: application/json',
            'Authorization: Basic ' . base64_encode($config['chatbot']['login'] . ':' . $config['chatbot']['password'])
        ]);

        curl_setopt($ch, CURLOPT_WRITEFUNCTION, function ($ch, $data) use (&$response) {
            echo $data;
            ob_flush();
            flush();
            return strlen($data);
        });
        curl_exec($ch);
        if (curl_errno($ch)) {
            $error = curl_error($ch);
            return $response->withStatus(500)->withHeader('Content-Type', 'application/json')
                ->withBody(new \Slim\Psr7\Stream(fopen('php://temp', 'r+')))
                ->write(json_encode(['errors' => $error]));
        }
        curl_close($ch);

        return $response->withHeader('Content-Type', 'application/json');
    }
}
