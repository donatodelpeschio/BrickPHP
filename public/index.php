<?php

/**
 * BrickPHP - Un micro-framework MVC leggero
 * @author Donato
 */

// 1. Carica l'Autoloader di Composer
require __DIR__ . '/../vendor/autoload.php';

// 2. Attiva il sistema di Error Handling e Logging globale
// Da questo momento in poi, ogni errore verrà catturato e loggato in storage/logs/app.log
\BrickPHP\Core\ErrorHandler::register();

use BrickPHP\Core\Http\Request;
use BrickPHP\Core\Router\Router;
use BrickPHP\Core\Dispatcher\Dispatcher;
use BrickPHP\Core\Http\Session;

// 3. Carica le variabili d'ambiente (.env)
if (file_exists(__DIR__ . '/../.env')) {
    $dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/../');
    $dotenv->load();
}

// 4. Inizializza la Sessione
$session = new Session();

// 5. Cattura la richiesta HTTP globale e inietta la sessione
$request = Request::capture();
$request->setSession($session);

// 6. Configura il Router e carica le rotte dell'utente
$router = new Router();
require __DIR__ . '/../config/routes.php';

// 7. Risoluzione della rotta (Match URL -> Controller)
// Se la rotta non viene trovata, il Router lancerà un'Exception 404
// che verrà gestita automaticamente dall'ErrorHandler.
[$handler, $params] = $router->resolve($request->getMethod(), $request->getPath());

// 8. Esecuzione (Dispatching)
$dispatcher = new Dispatcher();
$response = $dispatcher->dispatch($handler, $params, $request);

// 9. Invia la risposta finale al browser
$response->send();