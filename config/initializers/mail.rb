Mail.defaults do
  retriever_method(
    :pop3,
    :address    => APP_CONFIG["pop"]["server"],
    :port       => 995,
    :user_name  => APP_CONFIG["pop"]["user"],
    :password   => APP_CONFIG["pop"]["pass"],
    :enable_ssl => true
  );
end