class compatibility {

  file { '/foo':
    ensure  => directory,
    seltype => 'default_t',
  }

}
