<?php

// 1. Definiamo la costante se non esiste (fondamentale per il Core)
if (!defined('BRICK_PATH')) {
    define('BRICK_PATH', dirname(__DIR__));
}

// 2. Inizializziamo i componenti base (Request e Sessione)
// Devono essere pronti PRIMA del router e del dispatcher
$session = new \BrickPHP\Core\Http\Session();
$request = \BrickPHP\Core\Http\Request::capture();
$request->setSession($session);

// 3. Carichiamo il Router
$router = new \BrickPHP\Core\Router\Router();

// 4. Carichiamo le rotte (usando BRICK_PATH invece di ../../)
require BRICK_PATH . '/config/routes.php';

try {
    // 5. Il Router trova la rotta
    [$handler, $params] = $router->resolve($request->getMethod(), $request->getPath());

    // 6. Il Dispatcher la esegue passando la Request già pronta
    $dispatcher = new \BrickPHP\Core\Dispatcher\Dispatcher();
    $response = $dispatcher->dispatch($handler, $params, $request);

} catch (\Exception $e) {
    // Usiamo l'ErrorHandler o una risposta di fallback
    $code = ($e->getCode() >= 400 && $e->getCode() < 600) ? $e->getCode() : 500;
    $response = new \BrickPHP\Core\Http\Response("<h1>Errore $code</h1><p>{$e->getMessage()}</p>", $code);
}

return $response;