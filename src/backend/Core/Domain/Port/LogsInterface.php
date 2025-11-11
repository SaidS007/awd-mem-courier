<?php

namespace MaarchCourrier\Core\Domain\Port;

use Monolog\Logger;

interface LogsInterface
{
    public static function initMonologLogger(array $logConfig, array $loggerConfig): Logger|array;
    public static function getLogType(string $logType): array;
    public static function getLogConfig(): ?array;
    public static function add(array $args): bool|array;
    public static function rotateLogFileBySize(array $file): void;
    public static function calculateFileSizeToBytes(string $value): ?int;
}
