<?php
   $filename = __DIR__  . "/" . $_GET['host'] . ".txt";
   $message  = $_GET['data'];
   echo $filename;
   echo file_put_contents($filename, $message);
?>
