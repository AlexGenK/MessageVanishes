// функции кодирования и декодирования сообщений на стороне клиента

function encrypt_message(message, password, target) {
	$(target).val(
		CryptoJS.AES.encrypt($(message).val(),$(password).val())
		);
}

function decrypt_message(message, password, target) {
	var d_m=CryptoJS.AES.decrypt($(message).val(),$(password).val()).toString(CryptoJS.enc.Utf8);
	$(target).val(
		 d_m ? d_m : "!!! Wrong password !!!"
		);
}