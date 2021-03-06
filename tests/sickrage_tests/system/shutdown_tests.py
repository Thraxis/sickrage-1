# coding=utf-8
# This file is part of SickRage.
#

# Git: https://github.com/PyMedusa/SickRage.git
#
# SickRage is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# SickRage is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with SickRage. If not, see <http://www.gnu.org/licenses/>.

"""
Test shutdown
"""

from __future__ import print_function

import os
import sys
import unittest

sys.path.insert(1, os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../lib')))
sys.path.insert(1, os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..')))

from six import iteritems
import sickbeard
from sickbeard.event_queue import Events
from sickrage.system.Shutdown import Shutdown


class ShutdownTests(unittest.TestCase):
    """
    Test shutdown
    """
    def test_shutdown(self):
        """
        Test shutdown
        """
        sickbeard.PID = 123456
        sickbeard.events = Events(None)

        test_cases = {
            0: False,
            '0': False,
            123: False,
            '123': False,
            123456: True,
            '123456': True,
        }

        unicode_test_cases = {
            u'0': False,
            u'123': False,
            u'123456': True,
        }

        for tests in test_cases, unicode_test_cases:
            for (pid, result) in iteritems(tests):
                self.assertEqual(Shutdown.stop(pid), result)


if __name__ == '__main__':
    print('=====> Testing %s' % __file__)

    SUITE = unittest.TestLoader().loadTestsFromTestCase(ShutdownTests)
    unittest.TextTestRunner(verbosity=2).run(SUITE)
