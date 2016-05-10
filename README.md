# Bambam

Securely organize, share and stream local genomic data.

## Description
Bambam is a rails web application to distribute data from local infrastructure in a safe and controlled manner. Bambam was originally developed by the [Applied Bioinformatics Core](https://abc.med.cornell.edu/) at [Weill Cornell Medicine](http://weill.cornell.edu/).

Users are able to access and share files in a local filesystem (available to the webserver). To prevent dissemination of protected data user are only able to share files within a set of controlled paths managed by Managers and Admins (see access control below). Access control is managed through by [devise](https://github.com/plataformatec/devise) and [rolify](https://github.com/RolifyCommunity/rolify).

Bambam offers users a way to stream their local sequencing data into sequencing viewers like [IGV](http://www.broadinstitute.org/software/igv/home) (running locally on port 60151), an integrated version of [IGV JS](http://igv.org/web/doc/) and the [UCSC Genome Browser](https://genome.ucsc.edu/). It also allows them to share their data with other users of Bambam or with external collaborators via time expired links.

Bambam reduces the load on the server IO by lazy loading directories and files as the user digs deeper into the filesystem.

A responsive design offers a clean UI on desktop, tablets and mobile, although its use might be limited to browsing and sharing files as some of the sequencing viewers tools are not available on all platforms.

### Users, Groups and access control
Authorization is handled through roles. **Admins** have super user privileges and are able to CRUD all records in the system. **Managers** are able to CRUD their own projects, invite users and control the ability of a given project user to update or destroy files in that project. **Regular users** need to be added to a project before they can access any files. Ability of a user to make changes to a given project controlled by project manager.  Users are by invitation only, and only users that have been granted inviting privileges by an administrator can can send out invitations. 

The application supports the creation of groups of users. Work remains on integrating groups membership into the application access control infrastructure. 

### Datapaths
Managers are granted access to a given datapath (aka filesystem path) by an application administrator. Any projects created by a manager must be within of these pre-approved datapaths.

### Projects and Tracks
Tracks files are organized within projects. Projects consist of a set of users and a set of tracks. A given user can belong to many different projects.  Track files can also be included in multiple projects, although internally they are represented as independent records. Within a project, a track can only be added once.

Only managers and admins can administer projects. In creating a project, a manager user selects a name for the project, the datapaths accessible and the desired users, as well as adding any tracks that should be in the project. You can set up as many projects as makes sense for your purposes.

Regular users who are members of a project can view and add tracks to the project, but they cannot change the project name nor the project users. Additionally, regular users can edit a track's name and path, but they cannot change the project that a given track is assigned to.

### Sharing Tracks
Users have the ability to create links that they can share with collaborators and services that do not have an account. These shared links expire after a period of time set by the users or can be deleted at any time.


## Installation

### Dependencies
Before starting you will need the ruby version specified in `Gemfile` available in your system. Use rvm or your preferred ruby installer. Other dependencies are clearly defined in the `Gemfile`, but is worth mentioning that we use `dot-env` to manage all configuration through environment variables.


#### Database
The software depends on Postgres 9.4+ as it uses json extensions to store key-value pairs in some columns.

#### Configuration
Configuration is done through the environment file (`.env`) but you might want to check the standard rails database configuration file (`config/database.yml`) for more settings.
You need to have a database installed and configured for access to the user specified in the environment file `.env` (see below).

#### Webserver
We use puma as our webserver to leverage its streaming features and recommend pairing it with nginx for optimal performance. This is an example nxing config:
```
location /bambam/assets {
  alias /path/to/bambam/public/assets;
  gzip_static on;
  expires 30d;
  add_header Pragma public;
  add_header Cache-Control "public, must-revalidate, proxy-revalidate";
}

location /bambam {
  alias /path/to/bambam/public;
  try_files $uri $uri.html @bambam;
}

location @bambam {
  proxy_redirect off;
  proxy_set_header X-Forwarded-Proto $scheme;
  proxy_set_header Host              $http_host;
  proxy_set_header X-Real-IP         $remote_addr;
  proxy_pass http://unix:/path/to/bambam/tmp/sockets/puma.sock;
}
```

### Installation instructions
First clone the repository and run bundler:
```
git clone https://github.com/luisico/bambam.git
cd Bambam
bundle install
```

Copy the environment sample file and edit with your own configuration:
```
cp .env.sample .env
```

Make sure your database has been properly initialized with the values specified in `.env` and start the application:
```
foreman run bundle exec rails
```
Open the application in the browser and follow one of the interactive tours that can be accessed from a small blue i icon on the left side of the browser window.

## Future
Evolution into a platform to share any local data with collaborators, regardless of size or type.

## Authors
Luis Gracia - [luisico](https://github.com/luisico)
John Richardson - [richardsonjm](https://github.com/richardsonjm)

And the endless conversations and testing of:
Jason Banfelder
Luce Skrabanek

## Contributing
Bambam is open source. To contribute please follow instructions below:

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Added some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License
<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

