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
            // 2. Usiamo il metodo find() che abbiamo aggiunto al QueryBuilder
            // È più pulito e restituisce già un singolo oggetto invece di un array
            $user = db()->table('users')->find($id);

            // Se l'utente non esiste
            if (!$user) {
                return new Response("Utente non trovato", 404);
            }

            // 3. Salva in Cache per 10 minuti
            cache()->set($cacheKey, $user, 600);
        }

        // 4. Ritorna la View con i dati
        // Nota: l'helper view() ora restituisce già un oggetto Response grazie al nostro fix negli helper
        return view('users.profile', [
            'title' => 'Profilo di ' . ($user->name ?? 'Utente'),
            'user'  => $user
        ]);
    }
}