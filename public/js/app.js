// функции кодирования и декодирования сообщений на стороне клиента.
// на сервер значения не передаются, здесь же проиcходит обработка ошбок.

function encrypt_message(message, password, target, error_field) {
	if ($(password).val().length<6) $(error_field).val("Password too small (min. 6 symbols)!");
	if ($(message).val()=='') $(error_field).val("Message can not to be empty!");
	$(target).val(
		CryptoJS.AES.encrypt($(message).val(),$(password).val())
		);
}

function decrypt_message(message, password, target) {
	var d_m=CryptoJS.AES.decrypt($(message).val(),$(password).val()).toString(CryptoJS.enc.Utf8);
	$(target).val(
		 d_m=="" ? "!!! Wrong password !!!" : d_m
		);
}