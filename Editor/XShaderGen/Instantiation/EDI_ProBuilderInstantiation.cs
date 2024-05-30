using System.Collections.Generic;
using UnityEngine;
#if XRP_SHADER_INSTANTIATION_META
{
    "ClassName": "EDI_ProBuilderShader",
    "Name": "XRender/Editor/ProBuilder",
    "OutputPath": "Assets/Res/Shader/SurfaceShaderLibrary/EDI_ProBuilder.shader",
    "MM": "ProBuilder",
    "SM": "SHADING_MODEL_STANDARD_PBR",
    "Owner": "QP4B",
    "Usage": "Editor",
    "Desc": "Shader For ProBuilder",
    "PMs": [],
    "Config": [
        "SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Option)",
        "SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Option)",
        "SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Option)",
        "SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Option)",
        "SetOptionAlphaCutoffEnable(ShaderOptionFlag.OptionalDisable)",
        "SetOptionZWrite(ShaderOptionFlag.OptionalEnable)",
        "SetOptionTransparentZWrite(ShaderOptionFlag.OptionalDisable)",
        "SetOptionRefraction(ShaderOptionFlag.OptionalDisable)",
        "SetSupportDotsInstancing(true)"
    ]
}
#endif

namespace UnityEditor.XRender.XShaderGen.Instantiation
{
    [SurfaceShaderInstantiationAttribute]
    public class EDI_ProBuilderShader : XSurfaceShader
    {
        public override string GetName() => "XRender/Editor/ProBuilder";
        public override string GetOwner() => "QP4B";
        public override string GetDesc() => "Shader For ProBuilder";
        public override SurfaceShaderUsage GetUsage() => SurfaceShaderUsage.Environment;
        public override string GetGenerateShaderPath() => "Assets/Res/Shader/SurfaceShaderLibrary/EDI_ProBuilder.shader";
        protected override string GetMaterialModelName() => "ProBuilder";
        protected override string GetShadingModelName() => "SHADING_MODEL_STANDARD_PBR";
        protected override List<PluginModelDesc> InitPluginModelDescs() => new()
        {
            // new PluginModelDesc {name = "DefaultPluginModel", needMultiCompile = false},
        };
        protected override void AdditionalConfig(SurfaceShaderConfig config)
        {
            config.SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Opaque);
            config.SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Trans);
            config.SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Alpha);
            config.SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Back);
            config.SetOptionAlphaCutoffEnable(ShaderOptionFlag.AlwaysDisable);
            config.SetOptionZWrite(ShaderOptionFlag.AlwaysEnable);
            config.SetOptionTransparentZWrite(ShaderOptionFlag.AlwaysDisable);
            config.SetOptionRefraction(ShaderOptionFlag.AlwaysDisable);
            config.SetSupportDotsInstancing(true);
            config.SetOptionSupportDecal(ShaderOptionFlag.AlwaysDisable);
            config.SetOptionDecalLayer(SurfaceShaderConfig.DecalLayer.Layer1);
        }
    }
}
//ss:[[1339071361]]

