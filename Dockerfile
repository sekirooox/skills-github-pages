FROM ruby:3.4.11-bookworm
WORKDIR /workspace
EXPOSE 4000 35729
CMD ["bash", "tools/serve.sh"]
