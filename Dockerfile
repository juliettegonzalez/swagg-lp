FROM ruby

RUN gem install json

RUN mkdir /var/SwaggLP/

COPY ./ /var/SwaggLP/

ENTRYPOINT ruby /var/SwaggLP/generate_endpoints.rb
