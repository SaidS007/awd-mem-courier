<?php

/**
 * Copyright Maarch since 2008 under license.
 * See LICENSE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Mode Enum
 * @author dev@maarch.org
 */

namespace MaarchCourrier\SignatureBook\Domain;

enum Mode: string
{
    case VISA = 'visa';
    case SIGN = 'sign';
}
