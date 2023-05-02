<?php

$cfg['blowfish_secret'] = 'your-blowfish-secret'; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */

$i = 0;
$i++;
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = 'localhost';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = false;

$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
$cfg['TempDir'] = '/var/www/html/phpmyadmin/tmp';