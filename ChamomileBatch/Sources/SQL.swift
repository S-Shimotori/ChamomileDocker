import SwiftKnex

func queryToCreateVideosTableMake(_ tableName: String) -> Create {
    return Create(table: tableName, fields: [
        Schema.Field(name: "contentId", type: Schema.Types.String()).asPrimaryKey(),
        Schema.Field(name: "title", type: Schema.Types.String()).charset(.utf8).asIndex(),
        Schema.Field(name: "description", type: Schema.Types.String()).charset(.utf8),
        Schema.Field(name: "tags", type: Schema.Types.String()).charset(.utf8),
        Schema.Field(name: "categoryTags", type: Schema.Types.String()).charset(.utf8),
        Schema.Field(name: "viewCounter", type: Schema.Types.Integer()).asUngisned(), //typo
        Schema.Field(name: "mylistCounter", type: Schema.Types.Integer()).asUngisned(), //typo
        Schema.Field(name: "commentCounter", type: Schema.Types.Integer()).asUngisned(), // typo
        Schema.Field(name: "startTime", type: Schema.Types.DateTime()).asIndex(),
        Schema.Field(name: "thumbnailUrl", type: Schema.Types.String()),
        Schema.Field(name: "communityIcon", type: Schema.Types.String()),
        Schema.Field(name: "schoreTimeshiftReserved", type: Schema.Types.Integer()),
        Schema.Field(name: "liveStatus", type: Schema.Types.String()) // ENUM?
    ])
}
