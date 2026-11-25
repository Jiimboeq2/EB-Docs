-- A tour of the platform services
--
-- The target and the install folder, the eb global, the crew transport's box id, the frame loop's own status line, folders and queued saves, and the window bridge's helpers - each in one line.
--
-- kind:      snippet
-- expect:    The target is isx, eb.now is the platform clock, the transport names this box, a queued save is written by flushAll, and the window bridge gives an empty list that is sent as [].
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform
-- id:        platform-services-tour

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real), its files on a table
local w = DOCS.world({ me = { name = "Fixturae" } })
local disk = require("data.lib.memdisk").install()

-- your script
local P = require("eb.platform")
local target = P.detect()                                   -- what the environment looks like
local folder = P.root()                                     -- "." offline; the EB folder in game
local g = P.installGlobal()                                 -- fills only what is missing (EB's start made it)
local box = P.relay().session()                             -- this box's id on the crew relay
local fs = P.files()
local made = fs.mkdirs("eb-docs-notes")                    -- a folder for a helper's files
local who = P.ui().me()                                     -- nil until EB's start names the character
fs.writeLater("eb-docs-example.txt", "one queued save")    -- no disk work now
local written = fs.flushAll()                               -- a cleanup or a task writes the queue
local landed = disk["eb-docs-example.txt"]
local status = P.pulse().status()                           -- the frame loop in one line
local empty = P.ui().emptyList()
print(("%s | box %s | %d save written | %s"):format(target, box, written, status:match("^frames") or status))

-- check
DOCS.eq(target, "isx", "EB for InnerSpace")
DOCS.eq(type(folder), "string", "root is a folder name")
DOCS.eq(g.now, eb.now, "the eb global is the one installGlobal returns")
DOCS.eq(box, "is1", "the session name is the box id")
DOCS.eq(written, 1, "flushAll wrote the queued save")
DOCS.eq(landed, "one queued save", "the whole text, once")
DOCS.check(made ~= nil, "mkdirs answers")
DOCS.check(who == nil or type(who) == "string", "ui.me is a name or nil")
DOCS.eq(fs.pending(), 0, "nothing left in the queue")
DOCS.eq(next(empty), nil, "an empty list for a window state")
DOCS.eq(require("eb.platform.isx.services.files_isx").parent("notes/helper.json"), "notes", "the folder part of a path")
