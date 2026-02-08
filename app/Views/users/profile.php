<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title><?= htmlspecialchars($title) ?></title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
<h1>Profilo Utente</h1>

<div class="card">
    <p><strong>Nome:</strong> <?= htmlspecialchars($user->name) ?></p>
    <p><strong>Email:</strong> <?= htmlspecialchars($user->email) ?></p>
</div>

<hr>
<footer>
    <small>Generato da **BrickPHP**</small>
</footer>
</body>
</html>