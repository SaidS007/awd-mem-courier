<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief LogsMock class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\Core\Mock;

use MaarchCourrier\Core\Domain\Port\LogsInterface;
use Monolog\Logger;

class LogsMock implements LogsInterface
{

    public static string $message = "";
    public static function initMonologLogger(array $logConfig, array $loggerConfig): Logger|array
    {
        return [];
    }

    public static function getLogType(string $logType): array
    {
        return [];
    }

    public static function getLogConfig(): ?array
    {
        return null;
    }

    public static function add(array $args): bool|array
    {
        self::$message = $args['eventId'];
        return $args;
    }

    public static function rotateLogFileBySize(array $file): void
    {
        // TODO: Implement rotateLogFileBySize() method.
    }

    public static function calculateFileSizeToBytes(string $value): ?int
    {
        return 0;
    }
}