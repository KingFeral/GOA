var
	reCAPTCHA_pubkey = "6LfY9QMAAAAAAJFxacxzbyGQgKKshUswt3PSC3Xr"




mob
	proc
		Show_reCAPTCHA(error)
			var/html = {"<html><body><form><script type="text/javascript"
   src="http://api.recaptcha.net/challenge?k=[reCAPTCHA_pubkey][error?"&error=[error]":""]">
</script>
<noscript>
   <iframe src="http://api.recaptcha.net/noscript?k=[reCAPTCHA_pubkey][error?"&error=[error]":""]"
       height="300" width="500" frameborder="0"></iframe><br>
   <textarea name="recaptcha_challenge_field" rows="3" cols="40">
   </textarea>
   <input type="hidden" name="recaptcha_response_field"
       value="manual_challenge">
</noscript>
	<input type="hidden" name="src" value="\ref[src]">
	<input type="hidden" name="action" value="recaptcha_submit">
	<input type="submit" value="Submit"></form></body></html>"}
			src << browse(html, "window=reCAPTCHA;can_close=0;size=375x200")


		reCAPTCHA_valid()
			src<<"waiting 10 seconds.."
			sleep(100)
			ezing = 0
			Social = 0
			Ztime = 0
			Dojotime = 0
			Staminatime = 0
			Skilltime = 0
			watercount = 0
			stunned = 0
			if(client) client.eye=src


		reCAPTCHA_invalid()
			src<<"Try relogging when you dont act exactly like a poorly programmed bot."
			del(src)


		reCAPTCHA_error(err)
			Show_reCAPTCHA(err)



	Topic(href, href_list[])
		if(href_list["action"] == "recaptcha_submit")
			src << browse(null, "window=reCAPTCHA")
			var/params = list("response" = href_list["recaptcha_response_field"], "challenge" = href_list["recaptcha_challenge_field"], "ip" = (client.address?(client.address):"127.0.0.1"))
			var/http[] = world.Export("http://mmservices.homelinux.org:18080/web/recaptcha_submit.php?[list2params(params)]")
			if(!http)
				world.log << "reCAPTCHA: no response, assuming valid."
				reCAPTCHA_valid()
			else
				var/valid = html_encode(file2text(http["CONTENT"]))
				if(valid == "true")
					reCAPTCHA_valid()
				else if(valid == "incorrect-captcha-sol")
					reCAPTCHA_invalid()
				else
					reCAPTCHA_error(valid)
		else
			return ..()