# coding=utf-8
from feedparser.api import parse

from sickbeard import logger

from sickrage.helper.exceptions import ex


def getFeed(url, params=None, request_hook=None):
    try:
        data = request_hook(url, params=params, returns='text', timeout=30)
        if not data:
            raise Exception

        feed = parse(data, response_headers={'content-type': 'application/xml'})
        if feed:
            if 'entries' in feed:
                return feed
            elif 'error' in feed.feed:
                err_code = feed.feed['error']['code']
                err_desc = feed.feed['error']['description']
                logger.log(u'RSS ERROR:[%s] CODE:[%s]' % (err_desc, err_code), logger.DEBUG)
        else:
            logger.log(u'RSS error loading data: ' + url, logger.DEBUG)

    except Exception as e:
        logger.log(u'RSS error: ' + ex(e), logger.DEBUG)

    return {'entries': []}
