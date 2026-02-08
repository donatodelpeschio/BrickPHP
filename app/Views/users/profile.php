<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title><?php echo $title; ?></title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
<h1>Profilo Utente</h1>
<div class="card">
    <p><strong>Nome:</strong> <?php echo $user->name; ?></p>
    <p><strong>Email:</strong> <?php echo $user->email; ?></p>
</div>

<hr>
<small>Generato da BrickPHP</small>
</body>
</html>