# Dockerized Atlassian Crucible

"Review code, discuss changes, share knowledge, and identify defects across SVN, Git, Mercurial, CVS, and Perforce." - [[Source](https://www.atlassian.com/software/crucible)]

## Supported tags and respective Dockerfile links

| Product |Version | Tags  | Dockerfile |
|---------|--------|-------|------------|
| Bitbucket | 3.10.3 | 3.10.3, latest | [Dockerfile](https://github.com/blacklabelops/crucible/blob/master/Dockerfile) |

## Related Images

You may also like:

* [blacklabelops/jira](https://github.com/blacklabelops/jira): The #1 software development tool used by agile teams
* [blacklabelops/confluence](https://github.com/blacklabelops/confluence): Create, organize, and discuss work with your team
* [blacklabelops/bitbucket](https://github.com/blacklabelops/bitbucket): Code, Manage, Collaborate
* [blacklabelops/crowd](https://github.com/blacklabelops/crowd): Identity management for web apps

# Make It Short

Docker-CLI:

Just type and follow the manual installation procedure in your browser:

~~~~
$ docker run -d -p 8080:8080 --name crucible blacklabelops/crucible
~~~~

> Point your browser to http://yourdockerhost:8080
