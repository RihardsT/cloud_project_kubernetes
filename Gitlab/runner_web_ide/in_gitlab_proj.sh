.gitlab/.gitlab-webide.yml

terminal:
  image: ubuntu:20.04
  script: sleep 60
  tags: [htz1]
  variables:
    HELLO: "WORLD"
