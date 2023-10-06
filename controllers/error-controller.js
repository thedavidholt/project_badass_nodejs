

const error_index = (req, res) => {
    res.status(404).render('404', { site_title: 'Project Badass', page_name: '404' })
    console.log('A user hit an error!')
}

module.exports = {
    error_index
}