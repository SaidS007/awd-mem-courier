<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Email Script
 * @author dev@maarch.org
 */

namespace Email\scripts;

// phpcs:disable
require 'vendor/autoload.php';
// phpcs:enable

use AcknowledgementReceipt\models\AcknowledgementReceiptModel;
use Email\controllers\EmailController;
use Email\models\EmailModel;
use Exception;
use SrcCore\models\DatabasePDO;
use User\models\UserModel;

//customId   = $argv[1];
//emailId    = $argv[2];
//userId     = $argv[3];
//encryptKey = $argv[4];
//options    = $argv[5];

// phpcs:disable
$options = empty($argv[5]) ? null : unserialize($argv[5]);

EmailScript::send([
    'customId'   => $argv[1],
    'emailId'    => $argv[2],
    'userId'     => $argv[3],
    'encryptKey' => $argv[4],
    'options'    => $options,
    'receivedReceipt' => $argv[6], // EDISSYUM - NCH01 Ajout d'un accusé de lecture | Ajout receivedReceipt
    'pjLinkChecked' => $argv[7] // EDISSYUM - AMO01 Rajout d'une option pour envoyer les PJ via liens épémères AJOUT de pjLinkChecked
]);
// phpcs:enable

class EmailScript
{
    /**
     * @param array $args
     *
     * @return array
     * @throws Exception
     */
    public static function send(array $args): array
    {
        $GLOBALS['customId'] = $args['customId'];

        DatabasePDO::reset();
        new DatabasePDO(['customId' => $args['customId']]);

        $currentUser = UserModel::getById(['id' => $args['userId'], 'select' => ['user_id']]);
        $GLOBALS['login'] = $currentUser['user_id'];
        $GLOBALS['id'] = $args['userId'];
        $GLOBALS['customId'] = $args['customId'];
        $_SERVER['MAARCH_ENCRYPT_KEY'] = $args['encryptKey'];

        $isSent = EmailController::sendEmail([
            'emailId' => $args['emailId'],
            'userId' => $args['userId'],
            'receivedReceipt' => $args['receivedReceipt'], // EDISSYUM - NCH01 Ajout d'un accusé de lecture ajout receivedReceipt
            'pjLinkChecked' => $args['pjLinkChecked'] // EDISSYUM - AMO01 Rajout d'une option pour envoyer les PJ via liens épémères - ajout pjLinkChecked
        ]);
        if (!empty($isSent['success'])) {
            EmailModel::update(
                [
                    'set'   => ['status' => 'SENT', 'send_date' => 'CURRENT_TIMESTAMP'],
                    'where' => ['id = ?'],
                    'data'  => [$args['emailId']]
                ]
            );
        } else {
            EmailModel::update(['set' => ['status' => 'ERROR'], 'where' => ['id = ?'], 'data' => [$args['emailId']]]);
        }

        //Options
        if (!empty($args['options']['acknowledgementReceiptId']) && !empty($isSent['success'])) {
            AcknowledgementReceiptModel::update(
                [
                    'set'   => ['send_date' => 'CURRENT_TIMESTAMP'],
                    'where' => ['id = ?'],
                    'data'  => [$args['options']['acknowledgementReceiptId']]
                ]
            );
        }

        return $isSent;
    }
}
