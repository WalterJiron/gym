document.addEventListener("DOMContentLoaded", () => {
    const toggle = document.getElementById("togglePassword");
    const input = document.getElementById("password");
    const eyesImg = document.getElementById("eyesImg");

    toggle.addEventListener("click", () => {

        if (input.type === "password") {
            input.type = "text";
            eyesImg.src = "./assets/img/ojoA.svg";
            input.placeholder = "Ingresa tu contraseña";
        } else {
            input.type = "password";
            eyesImg.src = "./assets/img/ojoC.svg";
            input.placeholder = "*******";
        }
    });
});