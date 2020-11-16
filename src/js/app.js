/* eslint no-console:0 */

// RailsUjs is *required* for links in Lucky that use DELETE, POST and PUT.
import Rails from "@rails/ujs";

// Turbolinks is optional. Learn more: https://github.com/turbolinks/turbolinks/
import Turbolinks from "turbolinks";

import './components/tabs.js';
import './components/notifications.js';

Rails.start();
Turbolinks.start();
