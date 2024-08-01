#!/bin/bash
# Copyright 2024 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

. $(dirname ${BASH_SOURCE})/util.sh

desc "This is a comment.  It will be printed, but not through the typing simulator."
desc "After this it will run a command."
desc "After each command, it will wait for <enter> to proceed."
run "date"
run "sleep 1"
desc_type "This one will be printed through the typing simulator."
run "date"
desc "If you set \$DEMO_RUN_FAST=1, the typing will go faster"
DEMO_RUN_FAST=1
run "echo \"this is a long command which would have taken a while to type out\""
desc "If you set \$DEMO_RUN_SPEED to a value between 1 and 1000, the typing will go slower or faster"
DEMO_RUN_SPEED=5
run "echo \"this is DEMO_RUN_SPEED=5\""
DEMO_RUN_SPEED=25
run "echo \"this is DEMO_RUN_SPEED=25, which is the default\""
DEMO_RUN_SPEED=100
run "echo \"this is DEMO_RUN_SPEED=100, which is fast enough to need more text here\""
desc "If you set \$DEMO_AUTO_RUN=1 it will not wait for input between commands"
DEMO_AUTO_RUN=1
run "echo \"This is the first command\""
run "echo \"This is the second command\""
run "echo \"This is the third command\""
unset DEMO_AUTO_RUN
desc "The output of the last command is in \$DEMO_RUN_STDOUT if you need it"
run "date"
run "echo \"$DEMO_RUN_STDOUT\""
desc "At the end it will wait for one last <enter>."
