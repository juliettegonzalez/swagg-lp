FROM ruby

RUN gem install json bson colorize
RUN mkdir /var/SwaggLP/

COPY ./ /var/SwaggLP/
RUN chmod -R a+x /var/SwaggLP/scripts

#ENTRYPOINT ruby /var/SwaggLP/generate_endpoints.rb
ENTRYPOINT ruby /var/SwaggLP/coordinator.rb
