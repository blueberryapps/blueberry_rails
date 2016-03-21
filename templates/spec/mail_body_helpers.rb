module MailBodyHelpers
  MULTIPART_CONTENT_TYPE = /multipart/

  # this will collect all parts including parts under multipart container
  # and returns array of parts
  def get_mail_body_parts(mail)
    if mail.content_type =~ MULTIPART_CONTENT_TYPE
      mail.body.parts.flat_map do |part|
        part.content_type =~ MULTIPART_CONTENT_TYPE ? part.parts : part
      end
    else
      # if mail is not multipart then whole mail is part
      # (with content type, body etc.)
      [mail]
    end
  end

  # this will return content for given type body
  # get_mail_body(mail, /plain/)
  # get_mail_body(mail, /html/)
  # get_mail_body(mail, /pdf/)
  def get_mail_body(mail, type)
    get_mail_body_parts(mail).detect { |p| p.content_type.match type }.decoded
  end

  # this will return content for given type body
  # get_mail_encoded_body(mail, /plain/)
  # get_mail_encoded_body(mail, /html/)
  # get_mail_encoded_body(mail, /pdf/)
  def get_mail_attachement_body(mail, type)
    get_mail_body_parts(mail).detect { |p| p.content_type.match type }.encoded
  end
end
