<?php
    $mpmUser = 'vitto';
    $mpmGroup = 'vitto';
    $siteDir = '/work/progr/webamp/sites';

    $domain = $argv[1] ?? null;
    $framework = $argv[2] ?? null;
    $mod_rewrite = (($argv[3] ?? null) == "yes");

    if (!$domain) {
        echo "Empty domain name".PHP_EOL;
        die(1);
    }

    $domainDir = $siteDir.'/'.$domain;
    $webDir = $siteDir.'/'.$domain.'/public_html';

    if ($framework == 'yii2my') {
        $webDir .= '/web';
    }

    if ($framework == 'yii2basic') {
        $webDir .= '/web';
    }
?>

<VirtualHost *:80>

    ServerName <?=$domain?><?=PHP_EOL?>
    ServerAlias www.<?=$domain?><?=PHP_EOL?>
    ServerAdmin webmaster@<?=$domain?><?=PHP_EOL?>
    DocumentRoot <?=$webDir?><?=PHP_EOL?>

    <Directory "<?=$webDir?>">
        AllowOverride All
        Options FollowSymLinks
        Require all granted
<?php if ($mod_rewrite):?>
        <?=PHP_EOL?>
        RewriteEngine on
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . index.php
<?php endif;?>
        <?=PHP_EOL?>
        DirectoryIndex index.php index.html
    </Directory>

    <IfModule mpm_itk_module>
        AssignUserId <?=$mpmUser?> <?=$mpmGroup?><?=PHP_EOL?>
    </IfModule>

    php_admin_value open_basedir "<?=$domainDir?>/public_html:<?=$domainDir?>/tmp:/tmp"
    php_value upload_tmp_dir "<?=$domainDir?>/tmp"
    php_value session.save_path "<?=$domainDir?>/tmp"

    php_flag display_startup_errors on
    php_flag display_errors on
    php_flag html_errors on
    php_flag log_errors off
    php_value error_reporting -1

    ErrorLog <?=$domainDir?>/logs/error.log
    CustomLog <?=$domainDir?>/logs/access.log combined

</VirtualHost>
