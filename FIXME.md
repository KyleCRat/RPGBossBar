## LibSimpleDB Migration: 
Profile selection should be set outside of this lib, this lib should not handle profiles.

The addon should set the profile it wants to use and this lib should just be a wrapper around the db with callbacks for changes. This way we can use Ace profiles, or any other profile system with this addon.
