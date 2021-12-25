<?php

declare(strict_types=1);

//require __DIR__.'/vendor/autoload.php';

// ecs.php

use PhpCsFixer\Fixer\ArrayNotation\ArraySyntaxFixer;
use PhpCsFixer\Fixer\ClassNotation\ClassDefinitionFixer;
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;
use Symplify\EasyCodingStandard\ValueObject\Set\SetList;

return static function (ContainerConfigurator $containerConfigurator): void {
    // A. full sets
    $containerConfigurator->import(SetList::PSR_12);
    //$containerConfigurator->import(SetList::CLEAN_CODE);
    //$containerConfigurator->import(SetList::PHP_CS_FIXER);
    //$containerConfigurator->import(SetList::STRICT);
    //$containerConfigurator->import(SetList::SPACES);
    
    $containerConfigurator->import(SetList::SYMPLIFY);
    // B. standalone rule
    $services = $containerConfigurator->services();
    $services->set(ArraySyntaxFixer::class)
        ->call('configure', [[
            'syntax' => 'short',
        ]])
    ;
    $services->set(ClassDefinitionFixer::class)
             ->call('configure', [[
             'space_before_parenthesis' => true,
             ]]);
};
