const std = @import("std");

test "basic test" {
    const box3d = @import("box3d");

    var worldDef = box3d.b3DefaultWorldDef();
    worldDef.gravity = .{
        .x = 0.0,
        .y = -10.0,
        .z = 0.0,
    };

    const worldID = box3d.b3CreateWorld(&worldDef);

    var groundBodyDef = box3d.b3DefaultBodyDef();
    groundBodyDef.position = .{ .x = 0.0, .y = -10.0, .z = 0.0 };

    const groundBodyID = box3d.b3CreateBody(worldID, &groundBodyDef);
    const groundBox = box3d.b3MakeBoxHull(50.0, 10.0, 50.0);
    const groundShapeDef = box3d.b3DefaultShapeDef();
    _ = box3d.b3CreateHullShape(groundBodyID, &groundShapeDef, &groundBox.base);

    var bodyDef = box3d.b3DefaultBodyDef();
    bodyDef.type = box3d.b3_dynamicBody;
    bodyDef.position = .{ .x = 0.0, .y = 4.0, .z = 0.0 };
    const bodyID = box3d.b3CreateBody(worldID, &bodyDef);
    const dynamicBox = box3d.b3MakeCubeHull(1.0);
    var shapeDef = box3d.b3DefaultShapeDef();
    shapeDef.density = 1.0;
    shapeDef.baseMaterial.friction = 0.3;

    _ = box3d.b3CreateHullShape(bodyID, &shapeDef, &dynamicBox.base);

    const timeStep = 1.0 / 60.0;
    const subStepCount = 4;
    for (0..90) |_| {
        box3d.b3World_Step(worldID, timeStep, subStepCount);
        const position = box3d.b3Body_GetPosition(bodyID);
        const rotation = box3d.b3Body_GetRotation(bodyID);

        std.debug.print("position = {any} / rotation = {any} \n", .{ position, rotation });
    }

    box3d.b3DestroyWorld(worldID);
}
