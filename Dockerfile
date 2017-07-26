FROM ubuntu:16.04

WORKDIR /etc/mail

RUN set -e && \
 apt-get update && \
 apt-get install -y sendmail

#RUN apt-get update && apt-get install -y sendmail

# Copy the modified sendmail.mc that enables listening on network
COPY sendmail.mc /etc/mail/sendmail.mc

# rebuild sendmail config and add access entries
RUN m4 sendmail.mc > sendmail.cf && \
 echo "Connect:172 RELAY" >> access && \
 echo "Connect:19 RELAY" >> access && \
 make

# Preserve configuration
VOLUME /etc/mail

EXPOSE 25

# Full sendmail debug
#CMD /usr/lib/sendmail -bD -X /proc/self/fd/1
CMD /usr/lib/sendmail -bD 
