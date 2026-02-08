<?php

namespace App\Controllers\Web;

use BrickPHP\Core\Http\Request;
use BrickPHP\Core\Http\Response;

class UserController
{
    public function show(Request $request, $id): Response
    {
        $cacheKey = "user_profile_{$id}";

        // 1. Prova a recuperare dalla Cache
        $user = cache()->get($cacheKey);

        if (!$user) {
            // 2. Se non c'è, usa il Query Builder
            $user = db()->table('users')
                ->where('id', '=', $id)
                ->get();

            // Se l'utente non esiste, lanciamo un errore (verrà gestito dal Dispatcher/ErrorHandler)
            if (!$user) {
                return new Response("Utente non trovato", 404);
            }

            $user = $user[0]; // Prendiamo il primo risultato

            // 3. Salva in Cache per 10 minuti (600 secondi)
            cache()->set($cacheKey, $user, 600);
        }

        // 4. Ritorna la View con i dati
        return view('users.profile', [
            'title' => 'Profilo di ' . $user->name,
            'user'  => $user
        ]);
    }
}