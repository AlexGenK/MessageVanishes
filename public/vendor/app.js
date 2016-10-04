function encrypt_message(message, password, target) {
	$(target).val(
		CryptoJS.AES.encrypt($(message).val(),$(password).val())
		);
}

function decrypt_message(message, password, target) {
	$(target).val(
		CryptoJS.AES.decrypt($(message).val(),$(password).val()).toString(CryptoJS.enc.Utf8) ? CryptoJS.AES.decrypt($(message).val(),$(password).val()).toString(CryptoJS.enc.Utf8) : "!!! Wrong password !!!"
		);
}