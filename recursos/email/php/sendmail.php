<?php
/**
 * Created by PhpStorm.
 * User: Jorge Hernández García
 * Date: 22/08/16
 * Time: 10:40 AM
 */

include_once "phpmailer/class.phpmailer.php";

try {
    $mail = new PHPMailer();
    $mail->setFrom($_POST["correo"], utf8_decode($_POST["nombre"]));
    $mail->addAddress("luisnaruto.17@gmail.com", '');
    $mail->Subject = utf8_decode("Mensaje desde sitio: " .$_POST["asunto"]);
    $mail->msgHTML('
        <p><strong>Bienvenido: </strong>' . $_POST["nombre"] . '</p>
        <p><strong>Usted se registro con: </strong>' . $_POST["correo"] . '</p>
        <p><strong>Su nick es: </strong>' . $_POST["nick"] . '</p>
        <p><strong>Mensaje: </strong><br>' . $_POST["mensaje"] . '</p>');


    if (!$mail->send()) {
        $result = json_encode(array(
            "success" => false,
            "message" => "No se pudo enviar el mensaje. Si el problema persiste, comuníquese con el desarrollador."
        ));
    } else {
        $result = json_encode(array(
            "success" => true,
            "message" => "Tu mensaje ha sido enviado con éxito. Pronto nos pondremos en contacto contigo."
        ));
    }
} catch (phpmailerException $e) {
    $result = json_encode(array(
        "success" => false,
        "message" => $e->errorMessage()
    ));

} catch (Exception $e) {
    $result = json_encode(array(
        "success" => false,
        "message" => $e->errorMessage()
    ));
}

echo $result;