using System.Collections.Generic;
using UnityEngine;
#if XRP_SHADER_INSTANTIATION_META
{
    "ClassName": "CH_TransmissionSlime",
    "Name": "XRender/Environment/TransmissionSlime",
    "OutputPath": "Assets/Res/Shader/SurfaceShaderLibrary/CH_TransmissionSlime.shader",
    "MM": "TransmissionSlime",
    "SM": "SHADING_MODEL_STANDARD_PBR",
    "Owner": "QP4B",
    "Usage": "Character",
    "Desc": "A Transmission Slime Material",
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
    public class CH_TransmissionSlime : XSurfaceShader
    {
        public override string GetName() => "XRender/Character/TransmissionSlime";
        public override string GetOwner() => "QP4B";
        public override string GetDesc() => "A Transmission Slime Material";
        public override SurfaceShaderUsage GetUsage() => SurfaceShaderUsage.Environment;
        public override string GetGenerateShaderPath() => "Assets/Res/Shader/SurfaceShaderLibrary/CH_TransmissionSlime.shader";
        protected override string GetMaterialModelName() => "CH_TransmissionSlime";
        protected override string GetShadingModelName() => "SHADING_MODEL_STANDARD_PBR";
        protected override List<PluginModelDesc> InitPluginModelDescs() => new()
        {
            // new PluginModelDesc {name = "DefaultPluginModel", needMultiCompile = false},
        };
        protected override void AdditionalConfig(SurfaceShaderConfig config)
        {
            config.SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Transparent);
            config.SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Option);
            config.SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Alpha);
            config.SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Back);
            config.SetOptionAlphaCutoffEnable(ShaderOptionFlag.AlwaysDisable);
            config.SetOptionZWrite(ShaderOptionFlag.OptionalEnable);
            config.SetOptionTransparentZWrite(ShaderOptionFlag.AlwaysDisable);
            config.SetOptionRefraction(ShaderOptionFlag.OptionalDisable);
            
            config.SetSupportDoublePassTransparent();
            config.SetSupportDoublePassPreZ();
        }
    }
}
// config.SetSurfaceType(SurfaceShaderConfig.SurfaceTypeOption.Transparent);
// config.SetSupportDoublePassTransparent();
// config.SetOptionTransQueue(SurfaceShaderConfig.TransQueue.Trans);
// config.SetAlphaBlendMode(SurfaceShaderConfig.BlendModeOption.Alpha);
// config.SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Back);
// config.SetOptionAlphaCutoffEnable(ShaderOptionFlag.AlwaysDisable);
// config.SetOptionZWrite(ShaderOptionFlag.OptionalEnable);
// config.SetOptionTransparentZWrite(ShaderOptionFlag.AlwaysDisable);
// config.SetOptionRefraction(ShaderOptionFlag.OptionalDisable);
// config.SetOptionCullMode(SurfaceShaderConfig.CullModeOption.Back);
//ss:[[-901051071]]

