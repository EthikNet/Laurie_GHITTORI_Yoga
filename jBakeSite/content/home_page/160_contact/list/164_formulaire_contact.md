title=Formulaire de contact
date=2026-04-08
type=org_openCiLife_block
category=parlons-en
formData={"to":"${webleger.site.forulaire.contact.general.email}", "method":"get" "enctype":"application/x-www-form-urlencoded", "sendLabel":"Contactez-moi", "dataTransform":{"type":"obfuscated", "obfuscatedKey":"${webleger.site.forulaire.contact.general.email.obfuscation-mask}"}  "fields":[{"id":"destinataire", "label":"Destinataire", "type":"text", "readOnly":"true", "value":"${webleger.site.forulaire.contact.general.email}", "specificClass":"form-control-plaintext", "dataTransform":{"type":"obfuscated", "id":"emailHideButton", "obfuscatedKey":"${webleger.site.forulaire.contact.general.email.obfuscation-mask}", "hiddenByButton":"true", "hiddenButtonLabel":"afficher l'e-mail"}}, {"id":"Nom", "label":"Nom", "type":"text", "name":"subject"}, {"id":"message", "label":"Message", "type":"textarea", "rows":10, "name":"body"}]}
hooks={"data":[{"position":"endItemSubContent", "action":"form.build", "renderOnce":true, "order":38}]}
status=published
order=164
~~~~~~
	