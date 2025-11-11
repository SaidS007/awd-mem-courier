<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Perform Action Checker Test class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\SignatureBook\Application\Action\Checker;

use MaarchCourrier\Basket\Domain\Basket;
use MaarchCourrier\Basket\Domain\Problem\BasketNotFoundProblem;
use MaarchCourrier\Group\Domain\Problem\GroupDoesNotExistProblem;
use MaarchCourrier\MainResource\Domain\MainResource;
use MaarchCourrier\SignatureBook\Application\Action\Checker\SignatureBookActionPermissionChecker;
use MaarchCourrier\Tests\Unit\Basket\Mock\BasketClauseServiceMock;
use MaarchCourrier\Tests\Unit\Basket\Mock\BasketRepositoryMock;
use MaarchCourrier\Tests\Unit\Basket\Mock\RedirectBasketRepositoryMock;
use MaarchCourrier\Tests\Unit\Group\Mock\GroupRepositoryMock;
use MaarchCourrier\Tests\Unit\MainResource\Mock\MainResourceRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Repository\VisaWorkflowRepositoryMock;
use MaarchCourrier\User\Domain\User;
use PHPUnit\Framework\TestCase;

class SignatureBookActionPermissionCheckerTest extends TestCase
{
    public BasketRepositoryMock $basketRepositoryMock;
    public BasketClauseServiceMock $basketClauseServiceMock;
    public GroupRepositoryMock $groupRepositoryMock;
    public MainResourceRepositoryMock $mainResourceRepositoryMock;
    public VisaWorkflowRepositoryMock $visaWorkflowRepositoryMock;
    public RedirectBasketRepositoryMock $redirectBasketRepositoryMock;
    public SignatureBookActionPermissionChecker $performActionValidator;
    public User $connectedUser;
    public User $basketOwner;


    protected function setUp(): void
    {
        $this->basketRepositoryMock = new BasketRepositoryMock();
        $this->basketClauseServiceMock = new BasketClauseServiceMock();
        $this->groupRepositoryMock = new GroupRepositoryMock();
        $this->mainResourceRepositoryMock = new MainResourceRepositoryMock();
        $this->visaWorkflowRepositoryMock = new VisaWorkflowRepositoryMock();
        $this->redirectBasketRepositoryMock = new RedirectBasketRepositoryMock();

        $this->mainResourceRepositoryMock->mainResource =
            (new MainResource())
                ->setResId(1)
                ->setSubject('Courrier test')
                ->setTypist((new User())->setId(6));

        $this->connectedUser = (new User())->setId(6);
        $this->basketOwner = (new User())->setId(19);

        $this->performActionValidator = new SignatureBookActionPermissionChecker(
            $this->basketRepositoryMock,
            $this->basketClauseServiceMock,
            $this->groupRepositoryMock,
            $this->mainResourceRepositoryMock,
            $this->visaWorkflowRepositoryMock,
            $this->redirectBasketRepositoryMock
        );
    }

    /**
     * @return void
     * @throws GroupDoesNotExistProblem
     * @throws BasketNotFoundProblem
     */
    public function testCannotCheckForValidationIfGroupDoesNotExistExpectProblem(): void
    {
        $this->groupRepositoryMock->doesGroupExist = false;
        $this->expectException(GroupDoesNotExistProblem::class);
        $this->performActionValidator->check(
            $this->mainResourceRepositoryMock->mainResource,
            $this->connectedUser,
            $this->basketOwner,
            1,
            0
        );
    }

    /**
     * @return void
     * @throws GroupDoesNotExistProblem
     * @throws BasketNotFoundProblem
     */
    public function testCannotCheckForValidationIfBasketIdFromParamsDoesNotExist(): void
    {
        $this->basketRepositoryMock->doesBasketExist = false;
        $this->expectException(BasketNotFoundProblem::class);
        $this->performActionValidator->check(
            $this->mainResourceRepositoryMock->mainResource,
            $this->connectedUser,
            $this->basketOwner,
            1,
            1
        );
    }

    /**
     * @return void
     * @throws GroupDoesNotExistProblem
     * @throws BasketNotFoundProblem
     */
    public function testCanPerformAnActionFromARedirectedBasket(): void
    {
        $this->redirectBasketRepositoryMock->isBasketAssignedToUserOfGroup = true;
        $result = $this->performActionValidator->check(
            $this->mainResourceRepositoryMock->mainResource,
            $this->connectedUser,
            $this->basketOwner,
            1,
            1
        );
        $this->assertTrue($result);
    }

    /**
     * @return void
     * @throws GroupDoesNotExistProblem
     * @throws BasketNotFoundProblem
     */
    public function testRefusePerformingAnActionIfMainResourceDoesNotExistInBasket(): void
    {
        $this->basketRepositoryMock->basket = (new Basket())
            ->setId(1);
        $this->mainResourceRepositoryMock->doesExistOnView = false;

        $result = $this->performActionValidator->check(
            $this->mainResourceRepositoryMock->mainResource,
            $this->connectedUser,
            $this->basketOwner,
            1,
            1
        );
        $this->assertFalse($result);
    }

    /**
     * @return void
     * @throws BasketNotFoundProblem
     * @throws GroupDoesNotExistProblem
     */
    public function testRefusePerformingAnActionIfCurrentWorkflowUserOfMainResourceIsNotFound(): void
    {
        $this->basketRepositoryMock->basket = (new Basket())
            ->setId(1);
        $this->visaWorkflowRepositoryMock->doesCurrentStepUserExist = false;

        $result = $this->performActionValidator->check(
            $this->mainResourceRepositoryMock->mainResource,
            $this->connectedUser,
            $this->basketOwner,
            1,
            1
        );
        $this->assertFalse($result);
    }

    /**
     * @return void
     * @throws BasketNotFoundProblem
     * @throws GroupDoesNotExistProblem
     */
    public function testRefusePerformingAnActionIfConnectedUserIsDifferentThanCurrentWorkflowUserOfMainResource(): void
    {
        $this->basketRepositoryMock->basket = (new Basket())
            ->setId(1);
        $this->connectedUser = $this->connectedUser->setId(99);

        $result = $this->performActionValidator->check(
            $this->mainResourceRepositoryMock->mainResource,
            $this->connectedUser,
            $this->basketOwner,
            1,
            1
        );
        $this->assertFalse($result);
    }

    /**
     * @return void
     * @throws GroupDoesNotExistProblem
     * @throws BasketNotFoundProblem
     */
    public function testBasketClauseWillPrepareIfNotEmpty(): void
    {
        $this->basketRepositoryMock->basket = (new Basket())
            ->setId(1)
            ->setClause('1=1');

        $result = $this->performActionValidator->check(
            $this->mainResourceRepositoryMock->mainResource,
            $this->connectedUser,
            $this->basketOwner,
            1,
            1
        );
        $this->assertTrue($result);
    }

    /**
     * @return void
     * @throws BasketNotFoundProblem
     * @throws GroupDoesNotExistProblem
     */
    public function testCanPerformAnAction(): void
    {
        $this->basketRepositoryMock->basket = (new Basket())
            ->setId(1)
            ->setClause('1=1');

        $result = $this->performActionValidator->check(
            $this->mainResourceRepositoryMock->mainResource,
            $this->connectedUser,
            $this->basketOwner,
            1,
            1
        );
        $this->assertTrue($result);
    }
}
