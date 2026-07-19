FROM mcr.microsoft.com/dotnet/runtime-deps:10.0-noble

ARG SONARRVERSION
ARG SONARRBRANCH=v5-develop

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates gosu \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/sonarr

COPY _artifacts/linux-x64/net10.0/Sonarr/ /opt/sonarr/
COPY docker/entrypoint.sh /usr/local/bin/sonarr-entrypoint

RUN chmod +x /usr/local/bin/sonarr-entrypoint /opt/sonarr/Sonarr \
  && find /opt/sonarr -maxdepth 1 -type f \( -name ffmpeg -o -name ffprobe \) -exec chmod +x {} \; \
  && if [ -n "$SONARRVERSION" ]; then printf 'ReleaseVersion=%s\nBranch=%s\n' "$SONARRVERSION" "$SONARRBRANCH" > /opt/sonarr/release_info; fi

VOLUME ["/config"]
EXPOSE 8989

ENTRYPOINT ["/usr/local/bin/sonarr-entrypoint"]
