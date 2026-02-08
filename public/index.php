<?php

/**
 * BrickPHP - Un micro-framework MVC leggero
 * @author Donato
 */

// 1. Definiamo la bussola del Framework
define('BRICK_PATH', dirname(__DIR__));

// 2. Carica l'Autoloader di Composer
require BRICK_PATH . '/vendor/autoload.php';

// 3. Attiva il sistema di Error Handling e Logging globale
\BrickPHP\Core\ErrorHandler::register();

// 4. Carica le variabili d'ambiente (.env)
if (file_exists(BRICK_PATH . '/.env')) {
    $dotenv = Dotenv\Dotenv::createImmutable(BRICK_PATH);
    $dotenv->load();
}

use BrickPHP\Core\Http\Request;
use BrickPHP\Core\Router\Router;
use BrickPHP\Core\Dispatcher\Dispatcher;
use BrickPHP\Core\Http\Session;

// 5. Inizializza la Sessione (Usa BRICK_PATH internamente per storage/sessions)
$session = new Session();

// 6. Cattura la richiesta HTTP globale e inietta la sessione
$request = Request::capture();
$request->setSession($session);

// 7. Configura il Router e carica le rotte dell'utente
$router = new Router();
require BRICK_PATH . '/config/routes.php';

try {
    // 8. Risoluzione della rotta (Match URL -> Controller)
    [$handler, $params] = $router->resolve($request->getMethod(), $request->getPath());

    // 9. Esecuzione (Dispatching)
    $dispatcher = new Dispatcher();
    $response = $dispatcher->dispatch($handler, $params, $request);

    // 10. Invia la risposta finale al browser
    $response->send();

} catch (\Exception $e) {
    // Se qualcosa va storto qui (es. 404), l'ErrorHandler registrato sopra
    // interverrà, ma per sicurezza gestiamo il lancio della risposta.
    throw $e;
}