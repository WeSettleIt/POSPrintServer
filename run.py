from posprintserver import app

if __name__ == '__main__':
    context = {
        'threaded': True
    }

    app.logger.info("POS Print Server starting. Debug: %s", app.config.get('DEBUG', False))

    app.run(host='0.0.0.0', port=app.config.get('PORT', 5001), debug=app.config.get('DEBUG', False), **context)
