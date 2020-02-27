<html>
<head><title>Currently running Raspberry Pis</title></head>
<body>
<h1>Currently running Raspberry Pis</h1>
<?php

echo "<table border=1 cellpadding=3><tr bgcolor=lightgrey>
<td><strong>host</strong></td><td><strong>internal IP</strong></td><td><strong>external IP</strong></td><td><strong>last seen</strong></td><td><strong>uptime</strong></td></tr>";

$files = glob("*.txt");

foreach ($files as $file) {

    if (time()-filemtime($file) > 24 * 3600) {
       $color = "red";
    } else if (time()-filemtime($file) > 1 * 3600) {
       $color = "yellow"; 
    } else {
       $color = "green";
    }

    echo "<tr >";

    $fileContent = rtrim(file_get_contents($file));
    
    $expl = explode("@", $fileContent);
    $host = $expl[0];
    echo "<td>$host</td>";

    $expl = explode(" via ", $expl[1]);
    $intIP = $expl[0]; 
    echo "<td>$intIP</td>";
    
    $expl = explode(", last seen: ", $expl[1]);
    $extIP = $expl[0]; 
    echo "<td>$extIP</td>";


    $expl = explode(", up ", $expl[1]);
    $date = $expl[0];
    echo "<td bgcolor=$color>$date</td>";
    echo "<td>up $expl[1]</td>";

    echo "</tr>";
#echo "<p>$fileContent</p>";
}

echo "</table>";
?>
</body>
</html>
