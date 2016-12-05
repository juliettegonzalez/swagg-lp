FROM ruby

RUN gem install json bson

RUN mkdir /var/SwaggLP/

COPY ./ /var/SwaggLP/

#ENTRYPOINT ruby /var/SwaggLP/generate_endpoints.rb
ENTRYPOINT ruby /var/SwaggLP/parameter_generator.rb
