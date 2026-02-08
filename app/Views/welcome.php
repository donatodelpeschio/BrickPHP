<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Benvenuto in BrickPHP</title>
    <style>
        :root { --primary: #ff3e00; --dark: #1a202c; --light: #f7fafc; }
        body { font-family: 'Segoe UI', system-ui, sans-serif; background: var(--light); color: var(--dark); margin: 0; display: flex; align-items: center; justify-content: center; height: 100vh; }
        .container { max-width: 600px; padding: 2rem; background: white; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); text-align: center; }
        h1 { color: var(--primary); font-size: 2.5rem; margin-bottom: 0.5rem; }
        p { line-height: 1.6; color: #4a5568; }
        .badge { display: inline-block; padding: 0.25rem 0.75rem; background: #edf2f7; border-radius: 20px; font-size: 0.85rem; font-weight: bold; margin: 5px; }
        .steps { text-align: left; background: #f8fafc; padding: 1rem; border-left: 4px solid var(--primary); margin-top: 1.5rem; }
        code { background: #e2e8f0; padding: 0.2rem 0.4rem; border-radius: 4px; font-family: monospace; }
        .footer { margin-top: 2rem; font-size: 0.8rem; color: #a0aec0; }
    </style>
</head>
<body>
<div class="container">
    <h1>🧱 BrickPHP</h1>
    <p>Il tuo nuovo progetto è pronto per essere costruito, mattone dopo mattone.</p>

    <div>
        <span class="badge">v<?= $version ?></span>
        <span class="badge">PHP <?= $phpVersion ?></span>
        <span class="badge">ENV: <?= strtoupper($env) ?></span>
    </div>

    <div class="steps">
        <strong>Cosa fare ora?</strong>
        <ol>
            <li>Modifica le tue rotte in <code>config/routes.php</code></li>
            <li>Crea un controller: <code>php brick make:controller NomeController</code></li>
            <li>Configura il database nel file <code>.env</code></li>
        </ol>
    </div>

    <p>Hai bisogno di aiuto? Consulta la documentazione o apri una issue su GitHub.</p>

    <div class="footer">
        Sviluppato con ❤️ da Donato & BrickPHP Community
    </div>
</div>
</body>
</html>