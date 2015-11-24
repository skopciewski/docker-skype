FROM jess/skype

ENV SKYPE_USER=skype

RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

COPY data/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["skype"]
