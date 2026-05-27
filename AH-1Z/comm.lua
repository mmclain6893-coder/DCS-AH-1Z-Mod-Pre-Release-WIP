local parameters =
{
    helicopter = true,
}

return utils.verifyChunk(utils.loadfileIn("Scripts/UI/RadioCommandDialogPanel/Config/LockOnAirplane.lua", getfenv()))(parameters)
