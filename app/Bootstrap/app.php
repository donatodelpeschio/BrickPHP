<?php
// Semplificazione del flusso nel bootstrap
$router = new \BrickPHP\Core\Router\Router();
require __DIR__ . '/../../config/routes.php';

try {
    // 1. Il Router trova la rotta
    [$handler, $params] = $router->resolve($request->getMethod(), $request->getPath());

    // 2. Il Dispatcher la esegue
    $dispatcher = new \BrickPHP\Core\Dispatcher\Dispatcher();
    $response = $dispatcher->dispatch($handler, $params, $request);

    //3. Inizializza la sessione
    $session = new \BrickPHP\Core\Http\Session();
    $request = \BrickPHP\Core\Http\Request::capture();
    $request->setSession($session);

} catch (\Exception $e) {
    $response = new \BrickPHP\Core\Http\Response($e->getMessage(), $e->getCode() ?: 500);
}

return $response;